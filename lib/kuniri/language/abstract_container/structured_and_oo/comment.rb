module Languages

  # @abstract Class responsible for handling comments.
  class Comment

    public

      # This method is responsible for handling comments.
      # @param pLine String to be analysed.
      # @return Returns nil if doesn't find any comment line, or returns a
      #         string with comments. Finally, if it find the final of
      #         multiple line comment it returns END_MULTIPLE_LINE_COMMENT.
      def get_comment(pLine)
        raise NotImplementedError
      end

      # This method is responsible for checking if is a single line comment.
      # @param pLine String for verify if is a single line comment.
      # @return Return true if is a single line comment, otherwise, return
      #         false.
      def is_single_line_comment?(pLine)
        raise NotImplementedError
      end

      # This method verify if it a multiple line comment.
      # @param pLine String for verify if is a multiple line comment.
      # @return Return true if is a multiple line comment, otherwise, return
      #         false.
      def is_multiple_line_comment?(pLine)
        raise NotImplementedError
      end

      # This method verify if it is the end of multiple line comment.
      # @param pLine String to be inspected.
      # @return Return true if is the end of multiple line comment, otherwise,
      #         return true.
      def is_multiple_line_comment_end?(pLine)
        raise NotImplementedError
      end

    protected

      # Detect if line has a comment or not.
      # @param pLine Line to inspect for find comment.
      # @return Return nil if not find comment, or return a row string with
      #         the comment inside.
      def detect_comment(pLine)
        raise NotImplementedError
      end

      def get_line_comment(pString)
        raise NotImplementedError
      end

  # End class
  end

# module
end 