def cc_to_s(c)
  c.decode.map(&:to_s).join("\n")
end

module Rubinius
  class CompiledCode
    class Instruction
      def to_s
        str = "#{Location::FORMAT}  %-20s" % [@ip, opcode]
        str << @args.map{ |a| a.inspect }.join(', ')
        if @comment
          str << "    # #{@comment}"
        end
        if !@args.empty? and @args[0].is_a? CompiledCode
          cc_to_s(@args[0]).split("\n").each do |line|
            str << "\n    " << line
          end
        end
        str
      end
    end
  end
end

def load(path, signature, version)
  Rubinius.primitive :compiledfile_load
  raise Rubinius::InvalidRBC, path
end

c = load(ARGV[0], 1, 2)
puts cc_to_s(c)
