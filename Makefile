# Tested with pyang 1.7.3

# You really need to run this from the top-level directory (not from
# inside the standards directory), otherwise you get a weird error
# from pyang:
# KeyError: <pyang.statements.Statement object at 0x4b43210>


PYANG_FLAGS = --strict --max-line-length=70 --lint --lint-modulename-prefix=bbf --lint-namespace-prefix=urn:bbf:yang: --verbose --path=src/main/yang

BBF_YANG_FILES = $(shell find src/main/yang/bbf -name "*.yang")
IETF_YANG_FILES = $(shell find src/main/yang/ietf -name "*.yang")

BUILD = target/pyang

DEPS = $(BUILD) $(BBF_YANG_FILES) $(IETF_YANG_FILES)


all: tree jstree

check:
	pyang $(PYANG_FLAGS) $(BBF_YANG_FILES) 

$(BUILD):
	mkdir -p $(BUILD)

tree: $(BUILD)/tree.txt

$(BUILD)/tree.txt: $(DEPS)
	pyang -f tree $(PYANG_FLAGS) $(BBF_YANG_FILES) -o $(BUILD)/tree.txt

jstree: $(BUILD)/jstree.html

$(BUILD)/jstree.html: $(DEPS)
	pyang -f jstree $(PYANG_FLAGS) $(BBF_YANG_FILES) -o $(BUILD)/jstree.html

sample: $(BUILD)/sample.xml

$(BUILD)/sample.xml:
	pyang -f sample-xml-skeleton $(PYANG_FLAGS) $(BBF_YANG_FILES) -o $(BUILD)/sample.xml


clean:
	rm -rf $(BUILD)
