module StateMachine

  NONE_HANDLING_STATE       ||= -1      # NONE state, just for controlling. 
  GLOBAL_FUNCTION_STATE     ||= 1       # Global state track.
  CONSTRUCTOR_STATE         ||= 2       # Constructor state track.
  METHOD_STATE              ||= 3       # Method state track.
  END_MULTIPLE_LINE_COMMENT ||= 4       # End of multiple line comment.

end