function mask = segmentLungs(CT)

    segmentation = CT < -500 & CT > -1000;
    segmentation = removeBCC(3, segmentation);
    segmentation = removeTrachea(segmentation);

    mask = CT;
    mask(~segmentation) = 0;

end

function I = removeBCC(n, I)
    
    for i = 1 : n
    
        % Obtener componentes conexos
        CC = bwconncomp(I);
        maxArea = realmin;

        for j = 1 : CC.NumObjects
        
            [currentArea, ~] = size(CC.PixelIdxList{j});

            if(currentArea > maxArea)
                maxArea = currentArea;
            end

        end

        % Eliminar componente conexo más grande
        C = bwareaopen(I, maxArea);
        I = I - C;
    
    end

    I = C;

end

function I = removeTrachea(I)

    SE = strel('sphere', 5);
    
    I = imfill(I, 26, 'holes');
    I = imerode(I, SE);
    I = bwareaopen(I, 200000);
    I = imdilate(I, SE);
    I = imfill(I, 26, 'holes');

end