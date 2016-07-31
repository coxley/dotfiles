from themer import ThemeActivator
import os

class SetWallpaper(ThemeActivator):
    def activate(self):
        os.system("feh --bg-fill " + self.theme_dir + "/wallpaper*")
