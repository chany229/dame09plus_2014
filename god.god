God.watch do |w|
w.name    = "web"
w.dir     = "/home/chany229/ruby/dame09plus"
w.start   = "thin start -C myapp.yml"
w.stop    = "thin stop -C myapp.yml"
w.restart = "thin restart -O -C myapp.yml"
w.log     = "/home/chany229/ruby/dame09plus/log/god.log"
w.keepalive(:memory_max => 200.megabytes, :cpu_max => 50.percent)
end

God.watch do |w|
w.name    = "faye"
w.dir     = "/home/chany229/ruby/dame09plus"
w.start   = "rackup lib/faye.ru -s thin -E production"
w.log     = "/home/chany229/ruby/dame09plus/log/faye.log"
w.keepalive
end
