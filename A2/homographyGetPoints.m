function coord = homographyGetPoints(pt, vec)
    x = pt(1);
    y = pt(2);
    h11 = vec(1);
    h12 = vec(2);
    h13 = vec(3);
    h21 = vec(4);
    h22 = vec(5);
    h23 = vec(6);
    h31 = vec(7);
    h32 = vec(8);
    h33 = vec(9);
    xprime1 = ((h11*x + h12*y + h13)/(h31*x + h32*y + h33));
    yprime1 = ((h21*x + h22*y + h23)/(h31*x + h32*y + h33));
    coord = [xprime1; yprime1];
end