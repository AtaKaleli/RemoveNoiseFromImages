function [Hbp,Hbr] = bandPassAndRejectFilters(TYPE,M,N,D0,n,W)

    for u=1:M
        for v=1:N
         D(u,v)=((u-(M/2))^2 + (v-(N/2))^2 )^(1/2);
         end
    end
    

    switch TYPE
        case 'ideal' 
             Hbr=zeros(M,N);
             Hbr((D0-(W/2)<D) & (D<=D0+W/2))=1;
             Hbp=1-Hbr;
        case 'butterworth'
             Hbp = 1./(1 + (D.*W./(D.^2-D0.^2)).^(2*n) );
             Hbr=1-Hbp;
        case 'gaussian'
             Hbr =exp(-(D.^2)./(2*(D0^2)));
             Hbp=1-Hbr; 
    end
end