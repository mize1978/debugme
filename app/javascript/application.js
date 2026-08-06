import "@hotwired/turbo-rails"
import "controllers"

// ─── Console Easter Egg ───
document.addEventListener("turbo:load", () => {
  console.log(
    "%c 🐈‍⬛ DebugMe %c built by mize ",
    "background:#7c3aed;color:#fff;font-size:13px;font-weight:bold;padding:5px 10px;border-radius:6px 0 0 6px;",
    "background:#0f172a;color:#c4b5fd;font-size:13px;font-weight:bold;padding:5px 10px;border-radius:0 6px 6px 0;"
  );
  console.log("%c \u2726 github.com/mize1978/debugme", "color:#a855f7;font-size:11px;padding-left:2px;");
});
