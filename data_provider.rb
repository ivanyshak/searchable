require 'json'

# move main searching logic to separate module to have possibility reuse it
module Searching

  def search(data, params)
    data.select do |x|
      # this case for matching Lisp Common == Common Lisp
      if ( params.split(" ").join(" ") == x["Name"] || params.split(" ").reverse.join(" ") == x["Name"] )
        puts x
      # this will find by type and creator
      elsif x["Designed by"].split(", ").include?(params) || x["Type"].split(", ").include?(params)
        puts x
      elsif ( params.split(", ") & x["Type"].split(", ")) == params.split(", ")
        puts x
        # match in different fields, e.g. `Scripting Microsoft` should return all scripting languages designed by "Microsoft"
      elsif ( params.split(", ") & x["Type"].split(", ")).any? && ( params.split(", ") & x["Designed by"].split(", ")).any?
        puts x
      end
    end
  end

end

class DataProvider
  extend Searching

  # we should include our database file
  def self.json_connection
    file = File.open "data.json"
    data = JSON.load file
  end

  def greeting
    puts "=" * 15
    puts "| Hi There |"
    puts "=" * 15
  end

  def initial_request
    greeting
    while 1 > 0 do
      puts "Please input youe search request... OR if you want quit type q"
      request = gets.chomp
      if request == 'q'
        break
      end
      data = DataProvider.json_connection
      DataProvider.search(data, request)
    end
  end

  # creation an instance far calling first method
  DataProvider.new().initial_request

end


