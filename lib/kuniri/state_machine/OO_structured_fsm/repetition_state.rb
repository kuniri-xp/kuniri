require_relative 'oo_structured_state.rb'

module StateMachine

  module OOStructuredFSM

    class RepetitionState < OOStructuredState

      @language

      def initialize(pLanguage)
        @language = pLanguage
      end

        def handle_line(pLine)
        end

      def method_capture
        reset_flag
        @language.rewind_state
      end

      def constructor_capture
        reset_flag
        @language.rewind_state
      end

      def function_capture
        reset_flag
        @language.rewind_state
      end

      def execute(pElementFile, pLine)
        repetition = @language.repetitionHandler.get_repetition(pLine)

        flag = @language.flagFunctionBehaviour 

        if (repetition)
          #Function
          if (flag == StateMachine::GLOBAL_FUNCTION_STATE)
            pElementFile.global_functions.last.add_repetition(repetition)
          #Method
          elsif (flag == StateMachine::METHOD_STATE)
            pElementFile.classes.last.methods.last.add_repetition(repetition)
          #Constructor
          elsif (flag == StateMachine::CONSTRUCTOR_STATE)
            pElementFile.classes.last.constructors
                        .last.add_repetition(repetition)
          end
        end

        if (@language.endBlockHandler.has_end_of_block?(pLine))
          if (flag == StateMachine::GLOBAL_FUNCTION_STATE)
            function_capture
          elsif (flag == StateMachine::METHOD_STATE)
            method_capture
          elsif (flag == StateMachine::CONSTRUCTOR_STATE)
            constructor_capture
          end
        end

        return pElementFile

      end

      private

        def reset_flag
          @language.flagFunctionBehaviour = StateMachine::NONE_HANDLING_STATE
        end
    
    # End class
    end

  # End OOStructuredFSM
  end

# End StateMachine
end
