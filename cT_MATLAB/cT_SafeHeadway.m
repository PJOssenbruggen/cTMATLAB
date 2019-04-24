% safe headway u in units of feet per second
function h = hsafe(u,l)
   umph = u * 3600/5280;
   gaps = umph/10;
   h    = l*gaps; % vehicle length = 14 feet
   if(h < 2*l) h = 2*l;
end