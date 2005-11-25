function dummy= prompt_value(object,stuff);
% function that ask user to prompt values
% 3/02/04  bx wrote it
default = object;
prompt2 = sprintf(stuff,default);
dummy = input(prompt2,'s');
if (isempty(dummy))
    dummy = default;
end
 