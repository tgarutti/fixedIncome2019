clc
clear

f = struct;
f.add = @fun1;
f.sub = @fun2;
f.mult = @fun3;
f.div = @fun4;
fields_f = fieldnames(f);



for i = 1:size(fields(f),1)
    field = fields_f{i};
    f{field}
end



function [c] = fun1(a,b)
c = a+b;
end

function [c] = fun2(a,b,c)
c = a-b;
end

function [c] = fun3(a,b)
c = a*b;
end

function [c] = fun4(a,b)
c = a/b;
end
