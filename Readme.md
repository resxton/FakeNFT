# FakeNFT 27_1

# Записи работы эпиков
Максим корзина: https://disk.yandex.ru/d/FZo-KgvTXz9wTQ
Сергей стата: https://disk.yandex.ru/d/mSGaKswFbMMhAA
Владимир профиль: https://drive.google.com/file/d/1S467hjlr2HlqtsAVnjoApTROsKt8DYm9/view?usp=sharing
Кирилл каталог: https://drive.google.com/file/d/1vnpY3BpGD3g8CEQpFeQTdGMG6WDTG3m4/view?usp=sharing

Swift 5.10, UIKit, SnapKit

🛠️ Инструменты
Установите необходимые инструменты:
```
brew install xcodegen
brew install swiftlint
brew install swiftformat
```

🚀 Начало работы
1. Клонирование репозитория
```
git clone https://github.com/resxton/FakeNFT.git
```
2. Настройки Git hooks
```
git config core.hooksPath .githooks
```
3. Переходим в `bash`, если оболочка не `bash`:
```
bash
```
4. Выполняем команду и вводим свой токен:
```bash
read -r -p "Enter your API token: " token && printf 'API_TOKEN = %s\n' "$token" > Secrets.xcconfig && echo "✅ Secrets.xcconfig sucessfully created!"
```
5. Генерация Xcode проекта
```
xcodegen generate
```

🧰 Инструменты разработки
1. XcodeGen
```
xcodegen generate
```
2. SwiftFormat
```
# Форматирование всего проекта
swiftformat .
```
3. SwiftLint
```
# Проверка всего проекта
swiftlint
```
