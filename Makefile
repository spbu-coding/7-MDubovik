include CONFIG.cfg

RESULT_DIR = res
TMP_FILE = file.tmp
SUCCESS_MSG = OK

# Виртуальная цель, необходима для установления порядка запуска
.PHONY: all, check, clean

# Получение всех файлов с расширением *.c
SOURCES = $(wildcard $(SOURCE_DIR)/*c)
# Получение всех файлов тестов (*.in)
TESTS = $(wildcard $(TEST_DIR)/*.in)
# Замена подстроки $(subst заменяемый_фрагмент, замена, текст)
RESULT = $(subst $(TEST_DIR), $(RESULT_DIR), $(TESTS:.in=.txt))
BUILDS = $(subst $(SOURCE_DIR), $(BUILD_DIR), $(SOURCES:.c=.o))

all: $(BUILD_DIR) $(BUILD_DIR)/$(NAME)

# %.o - любое название файла с расширением *.o
# Автоматические переменные $<, $@
# $< Имя первого пререквизита
# $@ Имя файла цели
# $^ Имена всех пререквизитов
 
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c
	$(CC) -c $< -o $@
$(BUILD_DIR)/$(NAME): $(BUILDS)
	$(CC) $^ -o $@

$(BUILD_DIR):
	mkdir $@
$(RESULT_DIR):
	mkdir $@

# Тестирование
$(RESULT_DIR)/%.txt: $(TEST_DIR)/%.in $(TEST_DIR)/%.out $(BUILD_DIR)/$(NAME)
	@test_out=$$(echo $< | sed 's/.in/.out/g'); \
	program_out=$(RESULT_DIR)/$(TMP_FILE); \
	$(BUILD_DIR)/$(NAME) $< > $$program_out; \
	cmp $$test_out $$program_out > $@; \
	if [$$? = 0]; \
		then echo $(SUCCESS_MSG) > $@; \
	fi

check: $(RESULT_DIR) $(RESULT) all
	@test_fail=0; \
	for filename in $(RESULT); \
	do \
		echo "Test $$filename:"; \
		cat $$filename; \
		if ["$$(cat $$filename)" != "$(SUCCESS_MSG)"]; \
		then test_fail=$$(($$test_fail + 1)); \
		fi; \
	done; \
	if [$$test_fail != 0]; \
	then exit 1;
	fi; \

clean:
	$(RM) $(BUILD_DIR)/*
	$(RM) -rf $(RESULT_DIR)













