require "http/client"


def bench(host)
  status = 0
  start = Time.now
  HTTP::Client.new("#{host}.herokuapp.com") do |c|
    status = c.get("/").status_code
  end
  duration = (Time.now-start).to_f * 1000

  print! "measure##{host}.response=#{duration} sample##{host}.status=#{status}\n"

end

def minimum_sleep(seconds)
  start = Time.now
  yield
  needed = seconds - (Time.now-start).to_f
  sleep needed if needed > 0
end

loop do
  minimum_sleep(1) do
    print! "heartbeat\n"
    ENV["HOSTS"].split(/,/).each { |host| bench host }
  end
end
