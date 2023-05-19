import configparser
import sys


if __name__ == "__main__":
    config = configparser.ConfigParser()
    config.optionxform = lambda option: option
    config.read("/home/gitpod/.astrarc")

    print(config.sections())

    configenv = configparser.ConfigParser()
    configenv.optionxform = lambda option: option

    with open(".newenv", "w") as outfile:
        with open(sys.argv[1]) as infile:
            outfile.write("[" + sys.argv[2] + "]\n")
            for line in infile:
                outfile.write(line)

    configenv.read(".newenv")
    section = sys.argv[2]
    configenv[section]["ASTRA_DB_SECURE_BUNDLE_URL"] = ""

    config[section] = configenv[section]

    with open("/Users/kirstenhunter/.astrarc", "w") as configfile:
        config.write(configfile)

    print(sys.argv[1])
    print(sys.argv[2])
