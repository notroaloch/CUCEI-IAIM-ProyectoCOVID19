function severity = getSeverity(lungVolume, damageVolumes)

    damageVolume = sum(damageVolumes);
    severity = damageVolume * 100 / lungVolume;

end