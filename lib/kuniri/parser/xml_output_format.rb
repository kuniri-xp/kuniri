require_relative 'output_format'

module Parser

  class XMLOutputFormat < OutputFormat

    public

      # @see OutputFormat
      def class_generate(pClass)

        # Special case, empty class.
        if (pClass.inheritances.empty? && pClass.attributes.empty? &&
            pClass.methods.empty? && pClass.constructors.empty?)
          return default_fields("class", pClass)
        else
          return default_fields("class", pClass, false)
        end

      end

      # @see OutputFormat
      def constructor_generate(pConstructor)

        # Special case, empty constructor
        if (pConstructor.parameters.empty? &&
            pConstructor.conditionals.empty? &&
            pConstructor.repetitions.empty?)
            return default_fields("constructor", pConstructor)
        else
          return default_fields("constructor", pConstructor)
        end

      end

      # @see OutputFormat
      def inheritance_generate(pClassInheritances)
        inheritanceString = []
        pClassInheritances.inheritances.each do |inheritance|
          inheritanceString.push("<inheritance name=\"#{inheritance}\" />")
        end
        return inheritanceString.join("\n")
      end

      # @see OutputFormat
      def method_generate(pMethod)
        # TODO
        return "<method name=\"TODO\">"
      end

      # @see OutputFormat
      def parameters_generate(pParameters)
        # TODO
        return "<parameter name=\"TODO\">"
      end

      # @see OutputFormat
      def attribute_generate(pAttribute)
        # TODO
        return "<attribute name=\"TODO\">"
      end

      # @see OutputFormat
      def function_generate(pFunction)
        # TODO
        return "<function name=\"TODO\">"
      end

      # @see OutputFormat
      def global_variable_generate(pGlobalVariable)
        # TODO
        return "<globalVariable name=\"TODO\">"
      end

      # @see OutputFormat
      def extern_requirement_generate(pRequire)
        # TODO
        return "<require name=\"TODO\">"
      end

      # @see OutputFormat
      def repetition_generate(pRepetition)
        # TODO
        return "<repetition type=\"TODO\" >"
      end

      # @see OutputFormat
      def module_generate(pModule)
        # TODO
        return "<module name=\"TODO\" \>"
      end


      # @see OutputFormat
      def conditional_generate(pConditional)
        # TODO
        return "<conditional type=\"TODO\">"
      end

    private

      def default_fields(pLabelField, pElement, pCloseIt=true)
        buildString = "<#{pLabelField} name=\"#{pElement.name}\" "
        buildString += "visibility=\"#{pElement.visibility}\""
        buildString += (pElement.comments.empty?) ? " " :
                        "\n\tcomments=\"#{pElement.comments}\" "
        buildString += (pCloseIt) ? "/>" : ">"
        return buildString
      end

  # class
  end

# module
end
