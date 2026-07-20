class ErrorLogsController < ApplicationController
  include ActionController::Live

  def new
    @error_log = ErrorLog.new
    @popular   = ErrorLog.where.not(output: nil).order(view_count: :desc).limit(5)
  end

  def create
    @error_log = ErrorLog.new(
      input:      params[:error_log][:input],
      ip_hash:    Digest::SHA256.hexdigest(request.remote_ip),
      view_count: 0
    )

    if @error_log.save
      redirect_to @error_log
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @error_log = ErrorLog.find(params[:id])
    @error_log.increment!(:view_count)
  end

  def stream
    @error_log = ErrorLog.find(params[:id])

    response.headers["Content-Type"]      = "text/event-stream"
    response.headers["Cache-Control"]     = "no-cache"
    response.headers["X-Accel-Buffering"] = "no"
    response.headers["Connection"]        = "keep-alive"

    sse = ActionController::Live::SSE.new(response.stream, retry: 300)

    begin
      generator  = ErrorLogGenerator.new(@error_log.input)
      raw_json   = ""

      generator.stream do |chunk|
        raw_json += chunk
        sse.write({ type: "chunk" }.to_json)
      end

      cleaned = raw_json.strip.gsub(/\A```(?:json)?\n?/, "").gsub(/\n?```\z/, "")
      data    = JSON.parse(cleaned)

      @error_log.update!(output: data["error_log"])

      sse.write(
        {
          type:          "complete",
          summary:       data["summary"],
          error_log:     data["error_log"],
          suggested_fix: data["suggested_fix"]
        }.to_json,
        event: "complete"
      )
    rescue JSON::ParserError => e
      @error_log.update!(output: raw_json)
      sse.write(
        {
          type:          "complete",
          summary:       { severity: 50, self_esteem: 50, action: 50, communication: 50, logic: 50 },
          error_log:     raw_json,
          suggested_fix: ["もう一度試してみてください", "深呼吸して", "大丈夫！"]
        }.to_json,
        event: "complete"
      )
    rescue => e
      sse.write({ type: "error", message: e.message }.to_json, event: "error")
    ensure
      sse.close
    end
  end

  def ranking
    @logs = ErrorLog.where.not(output: nil)
                    .order(view_count: :desc)
                    .limit(20)
  end
end
