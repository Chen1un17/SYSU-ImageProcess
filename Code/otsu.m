function level = otsu(histogramCounts, total)
sumB = 0;
wB = 0;
maximum = 0.0;
threshold1 = 0.0;
threshold2 = 0.0;
sum1 = sum((1:256).*histogramCounts.');
for ii=1:256
    wB = wB + histogramCounts(ii);
    if (wB == 0)
        continue;
    end
    wF = total - wB;
    if (wF == 0)
        break;
    end
    sumB = sumB +  ii * histogramCounts(ii);
    mB = sumB / wB;
    mF = (sum1 - sumB) / wF;
    between = wB * wF * (mB - mF) * (mB - mF);
    if ( between >= maximum )
        threshold1 = ii;
        if ( between > maximum )
            threshold2 = ii;
        end
        maximum = between;
    end
end
level = (threshold1 + threshold2 )/(2);
end