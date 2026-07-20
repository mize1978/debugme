Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))

# 診断作成: IP単位で1時間に20回まで
Rack::Attack.throttle("error_logs/ip", limit: 20, period: 1.hour) do |req|
  req.ip if req.post? && req.path == "/error_logs"
end

# 全リクエスト: IP単位で1分間に60回まで（ブルートフォース防止）
Rack::Attack.throttle("req/ip", limit: 60, period: 1.minute) do |req|
  req.ip
end

Rack::Attack.throttled_responder = lambda do |req|
  [429, { "Content-Type" => "text/plain" }, ["Too Many Requests. しばらく待ってから再試行してください。"]]
end
