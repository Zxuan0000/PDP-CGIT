function center = getCenter(CurrentPOS, LastPOS)
    %Elite_sols: POS of previous environment
    %n: num of individual
    %d: num of decision variable

    LastPOS_center = mean(LastPOS, 2);
    CurrentPOS_center = mean(CurrentPOS, 2);

    center = CurrentPOS_center - LastPOS_center;
end