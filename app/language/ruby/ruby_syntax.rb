require_relative '../language'
require_relative 'ruby_syntax_support'
require_relative '../class_data'
require_relative 'token_ruby.rb'

module Languages

  # Handling the ruby syntax for extract information.
  class RubySyntax < Languages::Language

    public

      def initialize
        clear_data
      end

      def clear_data
        @rubySyntaxSupport = Languages::RubySyntaxSupport.new
        #You have to make it more generic, for the case of many class.
        @currentClass = Languages::ClassData.new
        @classes = []
        @visibility = "public"
        @class_token = 0
        @token = 0
        @attributeList = []
      end

      def analyse_source(path)
        analyse_first_step(path)
        #self.analyse_second_step
      end

      # Extract all the comments from the source.
      # @param source [String] Source code to analys.
      def comment_extract
        all_comments = Array.new
        #Find a simple Ruby comment with '#'
        @source.scan(/#(.*)/).each do |comments|
          all_comments.push(comments[0])
        end
        #Find multiple line comment.
        @source.scan(/^=begin(.*?)^=end/m).each do |comment|
          all_comments.push(comment[0].lstrip)
        end
        return all_comments
      end

      # Extract all method from the source.
      # @param source [String]
      def method_extract
        return @currentClass.get_methods
      end

      # Extract all the class declared in the source.
      # @param source [String]
      def class_extract
        return @currentClass
      end

      # @param source [String]
      def attribute_extract
        return @currentClass.get_attributes
      end

      # @param source [String]
      def global_variable_extract
        raise NotImplementedError
      end

      def dumpData
        puts "=" * 30
        puts @currentClass.dumpClassData
        puts "_" * 30
        puts @token
      end

    private

      @class_token
      @token
      @rubySyntaxSupport
      @classes
      @currentClass
      attr_accessor :visibility
      @source
      @attributeList

      def analyse_first_step(path)
        @source = File.open(path, "rb")
        @source.each do |line|
          tokenType = @rubySyntaxSupport.get_token_type(line)
          if tokenType == Languages::Ruby::CLASS_TOKEN || @class_token > 0
            tokenType = @rubySyntaxSupport.get_token_type(line, true)
            handle_class(tokenType, line)
          else
            handle_nonclass(line)
          end
        end
      end

      def handle_class(tokenType, line)
        case tokenType
          when Languages::Ruby::CLASS_TOKEN
            save_class(line)
            @class_token = @class_token + 1
            @token = @token + 1
          when Languages::Ruby::ATTRIBUTE_TOKEN
            save_attribute(line)
          when Languages::Ruby::DEF_TOKEN
            save_method(line)
            @token = @token + 1
          when Languages::Ruby::END_TOKEN
            @token = @token - 1
          when Languages::Ruby::VISIBILITY_TOKEN
            update_visibility(line)
          else
            return
          end
      end

      def handle_nonclass(line)
        return line
      end

      def save_class(line)
        # Regex in the line
        @currentClass.name = @rubySyntaxSupport.get_class_name(line)
        @classes.push(@currentClass)
        # Get inherintance
      end

      def save_attribute(line)
        attributeName = @rubySyntaxSupport.get_attribute(line)
        return if @attributeList.include?(attributeName)
          return
        end
        @attributeList.push(attributeName)
        attribute = Languages::AttributeData.new(attributeName)
        attribute.visibility = @visibility
        @currentClass.add_attribute(attribute)
      end

      def save_method(line)
        method_name = @rubySyntaxSupport.get_method(line)
        method = Languages::MethodData.new(method_name)
        method.visibility = @visibility
        @currentClass.add_method(method)
      end

      def update_visibility(line)
        @visibility = @rubySyntaxSupport.get_visibiliy(line)
      end
  end
end