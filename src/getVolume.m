function volume = getVolume(I)

    props = regionprops3(I, "Volume");
    totalVolume = sum(props.Volume);
    volume = totalVolume / 1000000;

end