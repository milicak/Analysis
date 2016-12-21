function [x]=year_mean(data)

months=[31 28 31 30 31 30 31 31 30 31 30 31]';
days=sum(months);
if(mod(length(data),12)==0)
  year=length(data)/12;
  data=reshape(data,[12 year]);
  months=repmat(months,[1 year]);
  x=data.*months;
  x=squeeze(nansum(x,1))./days;
else
error
end

