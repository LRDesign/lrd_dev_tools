
module Rails
  module Generators
    class GeneratedAttribute
      def default_value
        @default_value ||= case type
          when :int, :integer               then "\"1\""
          when :float                       then "\"1.5\""
          when :decimal                     then "\"9.99\""
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string, :text               then "\"value for #{@name}\""
          when :boolean                     then "false"
          else
            ""
        end      
      end

      def default_factory_value
        @default_factory_value ||= case type
          when :int, :integer               then "1"
          when :float                       then "1.5"
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string, :text               then "\"value for #{@name}\""
          when :boolean                     then "false"
          else
            "\"\""
        end
      end
      
      def name_or_reference
        if ::Rails::VERSION::STRING >= '2.2'
          reference? ? :"#{name}_id" : name
        else
          name
        end
      end
      
    end
  end
end