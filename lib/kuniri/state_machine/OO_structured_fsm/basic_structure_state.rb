#
# Copyright (C) 2015-2017 Rodrigo Siqueira  <siqueira@kuniri.org>
#
# This source code is licensed under the GNU lesser general public license,
# Version 3.  See the file COPYING for more details

require_relative 'oo_structured_state'
require_relative '../../language/abstract_container/structured_and_oo/global_tokens.rb'

module StateMachine

  module OOStructuredFSM

    # Class responsible for handling Basic structures state. Understand basic
    # basic structure by conditional and repetitions.
    class BasicStructureState < OOStructuredState

      def initialize(pLanguage)
        @language = pLanguage
        @language.resetNested
        @whoAmI = 'the fu@!+ nobody'
      end

      def handle_line(pLine)
        if !(conditional = @language.line_inspect(CONDITIONAL_ID, pLine)).nil?
          conditional_capture if nested_structure?(conditional.type)
        elsif !(repetition = @language.line_inspect(REPETITION_ID, pLine)).nil?
          repetition_capture if nested_structure?(repetition.type)
        elsif !(block = @language.line_inspect(BLOCK_ID, pLine)).nil?
          block_capture if nested_structure?(block.type)
        # aggregation
        end
      end

      # @see OOStructuredState
      def idle_capture
        @language.rewind_state
      end

      # @see OOStructuredState
      def method_capture
        @language.rewind_state
      end

      # @see OOStructuredState
      def constructor_capture
        @language.rewind_state
      end

      # @see OOStructuredState
      def conditional_capture
        @language.moreNested
        @language.set_state(@language.conditionalState)
      end

      # @see OOStructuredState
      def repetition_capture
        @language.moreNested
        @language.set_state(@language.repetitionState)
      end

      # @see OOStructuredState
      def block_capture
        @language.moreNested
        @language.set_state(@language.blockState)
      end

      # @see OOStructuredState
      def function_capture
        @language.rewind_state
      end

      # @see OOStructuredState
      def aggregation_capture
        @language.set_state(@language.aggregationState)
      end

      # @see OOStructuredState
      def execute(pElementFile, pLine)
        flag = @language.flagFunctionBehaviour
        classIndex = pElementFile.get_last_class_index
        add_to_correct_element(pElementFile, flag, classIndex)

        element = @language.processed_line
        singleLine = element.nil? ? false : element.singleLine
        if (@language.endBlockHandler.has_end_of_block?(pLine) || singleLine)
          update_level(flag, pElementFile, classIndex)
        end
        return pElementFile
      end

      protected

      @whoAmI # !@param whoAmI Used for differentiated child class.

      # If is a structure which can be nested. It is delegate.
      # @param pType Constant with type description.
      def nested_structure?(pType)
        if pType == Languages::WHILE_LABEL ||
           pType == Languages::FOR_LABEL ||
           pType == Languages::DO_WHILE_LABEL ||
           pType == Languages::UNTIL_LABEL ||
           pType == Languages::IF_LABEL ||
           pType == Languages::CASE_LABEL ||
           pType == Languages::UNLESS_LABEL ||
           pType == Languages::BLOCK_LABEL
          return true
        end
        return false
      end

      # Add element to correct place, based on the state machine position.
      # @pElement Specific element, e.g, conditional or repetition object.
      # @pElementFile All data.
      # @pFlag Flag with current position in the state machine.
      # @pClassIndex Index of class.
      def add_to_correct_element(pElementFile, pFlag, pClassIndex)
        pElement = @language.processed_line || return

        elementType = pElement.type
        stringToEval = "classes[#{pClassIndex}]."
        case pFlag
        when StateMachine::GLOBAL_FUNCTION_STATE
          dynamically_add(pElementFile, pElement, elementType,
                          'global_functions')
        when StateMachine::METHOD_STATE
          dynamically_add(pElementFile, pElement, elementType,
                          stringToEval + 'methods')
        when StateMachine::CONSTRUCTOR_STATE
          dynamically_add(pElementFile, pElement, elementType,
                          stringToEval + 'constructors')
        when StateMachine::SCRIPT_STATE
          pElementFile.add_repetition(pElement) ||
            pElementFile.add_block(pElement) ||
            pElementFile.add_conditional(pElement)
          if (@language.isNested? && nested_structure?(elementType))
            pElementFile.managerCondAndLoop.down_level
          end
        end
      end

      # Dynamically add based on child class.
      # @param pElementFile All data inside element.
      # @param pToAdd Element to add.
      # @param pType Type of the element.
      # @param pElement Element description.
      def dynamically_add(pElementFile, pToAdd, pType, pElement)
        classIndex = pElementFile.get_last_class_index
        index = eval("pElementFile.#{pElement}.length - 1")
        if (@language.isNested? && nested_structure?(pType))
          eval("pElementFile.#{pElement}[index]." \
                'managerCondAndLoop.down_level')
        end
        eval("pElementFile.#{pElement}[index].add_#{@whoAmI}(pToAdd)")
      end

      # Update nested level in conditional or repetition.
      # @param pFlag
      # @param pElementFile
      # @param pClassIndex
      def update_level(pFlag, pElementFile, pClassIndex)
        case pFlag
        when StateMachine::GLOBAL_FUNCTION_STATE
          dynamic_level_update(pElementFile, 'global_functions')
        when StateMachine::METHOD_STATE
          stringMethod = "classes[#{pClassIndex}].methods"
          dynamic_level_update(pElementFile, stringMethod)
        when StateMachine::CONSTRUCTOR_STATE
          stringMethod = "classes[#{pClassIndex}].constructors"
          dynamic_level_update(pElementFile, stringMethod)
        when StateMachine::SCRIPT_STATE
          @language.isNested? && pElementFile.managerCondAndLoop.up_level
        end
        @language.rewind_state
        @language.lessNested
      end


      # Update level of conditional or repetition
      # @param pElementFile Element with all data.
      # @param pElement String name of the element.
      def dynamic_level_update(pElementFile, pElement)
        @language.isNested? || return
        target = "pElementFile.#{pElement}[pElementFile.#{pElement}" \
                 '.length - 1].managerCondAndLoop.up_level'
        eval(target)
      end

    end # End class
  end # End OOStructuredFSM
end # End StateMachine
