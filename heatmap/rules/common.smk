def get_bigwig(wildcard):
    return samples.loc[:,'bigwig'].dropna()

def get_samples(wildcard):
    sample_series = samples.loc[:,"sample"].dropna()
    sample_list = sample_series.tolist()
    return sample_list


def get_peaks(wildcard):
    return peaks.loc[:,"peaks"].dropna()

def get_color(wildcard):
    color = samples.loc[:,"color"].dropna()
    return color.tolist()

def get_profile_color(wildcard):
    profile_color = samples.loc[:,'profileColor'].dropna()
    return profile_color.tolist()


def get_yMin(wildcard):
    yMin = samples.loc[:,"yMin"].dropna()
    yMin_list = yMin.tolist()
    return " ".join(map(str,yMin_list))

def get_yMax(wildcard):
    yMax = samples.loc[:,"yMax"].dropna()
    yMax_list = yMax.tolist()
    return " ".join(map(str,yMax_list))

def get_zMin(wildcard):
    zMin = samples.loc[:,"zMin"].dropna()
    zMin_list = zMin.tolist()
    return " ".join(map(str,zMin_list))

def get_zMax(wildcard):
    zMax = samples.loc[:,"zMax"].dropna()
    zMax_list = zMax.tolist()
    return " ".join(map(str,zMax_list))
