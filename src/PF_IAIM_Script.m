clc;
clear;
close all;

%% Seleccionar CT

[file, path] = uigetfile('*.*');

if(file == 0)
    return;
end

filePath = strcat(path, file);
CT = nrrdread(filePath);
disp(strcat("ARCHIVO CARGADO: ", filePath));

%% Segmentación de Pulmones

disp("INICIANDO - SEGMENTACIÓN DE PULMONES");

% lungs.Image = segmentLungs(CT);
% lungs.Image = segmentLungsV2(CT); % 57% más rápido pero tiene traquea
lungs.Image = segmentLungsV3(CT);

volumeViewer(lungs.Image);

disp("TERMINADO - SEGMENTACIÓN DE PULMONES");

%% Segmentación de Daño

disp("INICIANDO - SEGMENTACIÓN DE DAÑO");

damage1.Image = lungs.Image < -901 & lungs.Image > -1000;
damage2.Image = lungs.Image < -100 & lungs.Image > -500;
damage3.Image = lungs.Image < -977 & lungs.Image > -1024;

damage4.Image = lungs.Image < -470 & lungs.Image > -730;
% damage4Props = regionprops3(damage4.Image, "Volume");
% damage4Volumes = sort(damage4Props.Volume, 'descend');
% damage4.Image = bwareaopen(damage4.Image, damage4Volumes(2, 1));


disp("TERMINADO - SEGMENTACIÓN DE DAÑO");

%% Calculo de Densidades y Volúmenes

disp("INICIANDO - CÁLCULO DE DENSIDADES Y VOLÚMENES");

lungs.Volume = getVolume(lungs.Image);
lungs.Density = getDensity(lungs.Image);

damage1.Volume = getVolume(damage1.Image);
damage1.Density = getDensity(damage1.Image);

damage2.Volume = getVolume(damage2.Image);
damage2.Density = getDensity(damage2.Image);

damage3.Volume = getVolume(damage3.Image);
damage3.Density = getDensity(damage3.Image);

damage4.Volume = getVolume(damage4.Image);
damage4.Density = getDensity(damage4.Image);

disp("TERMINADO - CÁLCULO DE DENSIDADES Y VOLÚMENES");

%% Mostrar Resultados

disp("PROGRAMA FINALIZADO - MOSTRANDO RESULTADOS");

volumeViewer(lungs.Image);

figure("Name", "Daño Tipo 1");
volshow(damage1.Image);

figure("Name", "Daño Tipo 2");
volshow(damage2.Image);

figure("Name", "Daño Tipo 3");
volshow(damage3.Image);

figure("Name", "Daño Tipo 4");
volshow(damage4.Image);
