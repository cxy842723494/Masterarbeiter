function [Y, U, V] = readYUVfolder(path)

Y = [];
U = [];
V = [];

folderContent = dir(path);

i = 1;

for k = 1 : size(folderContent, 1)
    if ~folderContent(k).isdir && ...
            strcmp(folderContent(k).name(end-3:end),'.yuv')
        [Y(:,:,i), U(:,:,i), V(:,:,i)] = ...
            functions.readYUV([path '/' folderContent(k).name]);
        i = i + 1;
    end
end

Y = single(Y);
U = single(U);
V = single(V);
end