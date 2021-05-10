function mat = homographyA(m)
    x1 = m(1);
    y1 = m(2);
    xprime1 = m(3);
    yprime1 = m(4);
    mat = [
            x1 y1 1 0 0 0 -x1*xprime1 -y1*xprime1 -xprime1;
            0 0 0 x1 y1 1 -x1*yprime1 -y1*yprime1 -yprime1
        ];
end