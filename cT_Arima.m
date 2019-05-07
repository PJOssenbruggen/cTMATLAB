function cT_Arima(s,mdl)
    figure('Name','Autocorr')
    subplot(3,2,1);
    autocorr(s);
    subplot(3,2,2)
    parcorr(s);
    EstMdl = estimate(mdl,s)
    res = infer(EstMdl,s);
    subplot(3,2,3)
    plot(res./sqrt(EstMdl.Variance))
    title('Standardized Residuals')
    subplot(3,2,4)
    qqplot(res)
    subplot(3,2,5)
    autocorr(res)
    subplot(3,2,6)
    parcorr(res)
end