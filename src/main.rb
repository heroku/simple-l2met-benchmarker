$stdout.sync = true
require "excon"

def bench(host)
  status = 0
  start = Time.now
  status = Excon.get("http://#{host}.herokuapp.com").status
  duration = Time.now - start

  puts "measure##{host}.response=#{duration}"
  puts "source=#{status} count##{host}.status=1"
end

def minimum_sleep(seconds)
  start = Time.now
  yield
  needed = seconds - (Time.now-start).to_f
  sleep needed if needed > 0
end

loop do
  minimum_sleep(1) do
    puts "heartbeat"
    ENV["HOSTS"].split(/,/).each do |host|
      20.times do
        Thread.new { bench host }
      end
    end
  end
end
