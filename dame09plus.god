God.watch do |w|
w.name = "dame09plus_thin"
w.dir = "/home/chany229/ruby/dame09plus"
w.start = "thin start -C myapp.yml"
w.log = "/home/chany229/ruby/dame09plus/log/thin.log"
w.keepalive
end