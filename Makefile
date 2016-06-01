include theos/makefiles/common.mk
ARCHS = armv7 arm64
TARGET=iphone:latest:5.1
TWEAK_NAME = hookdd
hookdd_FILES = Tweak.xm
hookdd_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 DingTalk"
