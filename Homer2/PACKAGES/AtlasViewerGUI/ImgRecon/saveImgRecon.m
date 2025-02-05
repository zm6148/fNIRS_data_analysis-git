function saveImgRecon(imgrecon, dirname)

if isempty(imgrecon)
    return;
end
if dirname(end)~='/' && dirname(end)~='\'
    dirname(end+1)='/';
end
dirnameOut = [dirname 'imagerecon/'];

Aimg_conc = imgrecon.Aimg_conc;
Aimg_conc_scalp = imgrecon.Aimg_conc_scalp;

HbO = Aimg_conc.HbO;
HbR = Aimg_conc.HbR;
if ~isempty(HbO) & ~isempty(HbO)
save([dirnameOut, 'Aimg_conc.mat'], 'HbO','HbR');
end

HbO = Aimg_conc_scalp.HbO;
HbR = Aimg_conc_scalp.HbR;
if ~isempty(HbO) & ~isempty(HbO)
    save([dirnameOut, 'Aimg_conc_scalp.mat'], 'HbO','HbR');
end

