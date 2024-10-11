function PopF = GetFbyPopX(PopX,Problem,t)
CostFunction=Problem.FObj;  % Cost Function
    PopF = [];
    for i=1:size(PopX,1)
       PopF(i,:) = CostFunction(PopX(i,:),t);
    end
end