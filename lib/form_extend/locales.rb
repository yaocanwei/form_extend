module FormExtend
  module I18n
    def self.included base
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def locales(*args)
        case args.size
        when 1
          ::I18n.t(*args)
        when 2
          if args.last.is_a?(Hash)
            ::I18n.t(*args)
          elsif args.last.is_a?(String)
            ::I18n.t(args.first, :value => args.last)
          else
            ::I18n.t(args.first, :count => args.last)
          end
        else
          raise "Translation string with multiple values: #{args.first}"
        end
      end
    end
  end
end