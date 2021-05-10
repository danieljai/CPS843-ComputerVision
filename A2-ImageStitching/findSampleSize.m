function N = findSampleSize(e, s, p)
    N = log(1-p) / log(1-(1-e)^s);
end