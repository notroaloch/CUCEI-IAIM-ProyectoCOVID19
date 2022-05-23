function mask = segmentLungsV2(CT)

    % Define un umbral de segmentación pulmonar
    HUSegmentation = CT < -374;
    
    % Obtiene los volumenes de los componentes conexos en orden descendente
    props = regionprops3(HUSegmentation, "Volume");
    volumes = sort(props.Volume, 'descend');
    
    % Orden de Componentes Conexos por Volumen
    % 1. Máquina CT
    % 2. Piel
    % 3. Pulmones
    
    % Elimina los CC más pequeños que los pulmones (ruido)
    I = bwareaopen(HUSegmentation, volumes(3, 1));
    
    % Elimina los CC más pequeños que la piel (pulmones)
    skin = bwareaopen(I, volumes(2, 1));
    
    % Obtiene segmentación de pulmones
    lungs = I - skin;
    
    % Erosiona para remover posibles restos de piel adherida
    SE = strel('sphere', 2);
    lungs = imerode(lungs, SE);

    % Genera la máscara de segmentación
    mask = CT;
    mask(~lungs) = 0;

end


