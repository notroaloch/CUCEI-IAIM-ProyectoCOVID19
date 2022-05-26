function mask = segmentLungsV3(CT)

    % Define un umbral de segmentación pulmonar
    HUSegmentation = CT < -374;
    
    SE = strel('sphere', 3);
    I = imerode(HUSegmentation, SE);

    % Obtiene los volumenes de los componentes conexos en orden descendente
    
    props = regionprops3(I, "Volume");
    volumes = sort(props.Volume, 'descend');
    
    % Volumenes de pulmones hard-codeados
    definedVolumes = [703245 411215 2576775 1603949];

    volumes = intersect(volumes, definedVolumes);
    smallestVolume = min(volumes);

    I = bwareaopen(I, smallestVolume);
    CC = bwconncomp(I);
    nObjects = CC.NumObjects - 2;

    lungs = removeBCC(nObjects, I);

    % Genera la máscara de segmentación
    mask = CT;
    mask(~lungs) = 0;

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

end


