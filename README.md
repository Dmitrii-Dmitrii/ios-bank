# DOBank - банковское приложение

## Архитектура - VIPER

Для банковского приложения важны:
- Разделение ответственности – удобство поддержки и тестирования.
- Гибкость и масштабируемость – легко добавлять новые функции.
- Тестируемость – возможность подменять зависимости моками.

Мой выбор – VIPER, так как:
- Четко разделяются слои: View, Interactor, Presenter, Entity, Router.
- Бизнес-логика (Interactor) будет легко тестироваться.
- Приложение будет гибким и поддерживаемым.

## Экраны приложения 

1. Экран авторизации (`Auth`) – вход в систему.
2. Главный экран (`Main`) – список услуг (баланс, переводы, история).
3. Экран баланса (`Balance`) – отображает текущий баланс.
4. Экран переводов (`Transfer`) – позволяет отправлять деньги.
5. Экран истории (`History`) – показывает список транзакций.

## Workflow

### `Auth`

- Пользователь вводит логин/пароль.
- Нажимает "Войти".
- `Interactor` проверяет учетные данные.
- Если успешно → переход на `MainScreen`.

### `Main`

- Загружает список доступных функций и список доступных счетов.
- При выборе функции → переход на соответствующий экран.

### `Balance`

- Запрашивает баланс пользователя.
- Отображает баланс на экране.

### `Transfer`

- Пользователь вводит сумму и номер счета.
- Подтверждает перевод.
- `Interactor` отправляет запрос в API.
- Если успешно → обновляет баланс.

### `History`

- Загружает список транзакций.
- Отображает историю.

## Методы

### Протоколы для экрана авторизации (Auth)

**AuthViewProtocol**
- `showError(message: String)`: Отображает ошибку авторизации на экране.

**AuthPresenterProtocol**
- `login(username: String, password: String)`: Принимает логин и пароль от пользователя и передает их в `Interactor` для выполнения аутентификации. Если аутентификация прошла успешно, передает данные пользователя в `Router` для перехода на главный экран. Если ошибка, сообщает View для отображения ошибки.

**AuthInteractorProtocol**
- `authenticate(username: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)`: Выполняет аутентификацию пользователя. Внутри метода происходит запрос к серверу или базе данных для проверки логина и пароля. Если успешна, возвращает объект `UserModel`. Если ошибка — возвращает ошибку.

**AuthRouterProtocol**
- `navigateToMainScreen(user: UserModel)`: После успешной аутентификации, маршрутизатор перенаправляет пользователя на главный экран, передавая модель пользователя, которая может быть использована для загрузки его данных и отображения на главном экране.

### Протоколы для экрана главного меню (Main)

**MainViewProtocol**
- `displayFeatures(_ features: [FeatureModel])`: Отображает доступные функции на главном экране в виде списка. Метод принимает массив объектов `FeatureModel`.
- `displayUserAccounts(_ accounts: [AccountModel])`: Отображает список аккаунтов пользователя, полученных из `Presenter`, включая информацию о каждом аккаунте.

**MainPresenterProtocol**
- `loadFeatures()`: Загружает доступные функции для пользователя. Обычно вызывает метод `Interactor` для получения данных о возможных функциях и передает эти данные в `View` для отображения.
- `didSelectFeature(_ feature: FeatureType)`: Обрабатывает выбор пользователем функции. Вызывает соответствующий метод в `Router` для навигации на соответствующий экран.
- `func loadUserAccounts(user: UserModel)`: Загружает доступные счета для пользователя. Вызывает метод `Interactor` для получения счетов и передает их в `View` для отображения.
- `func didSelectAccount(_ account: AccountModel)`: Обрабатывает выбор пользователем счета и сохраняет его.

**MainInteractorProtocol**
- `getAvailableFeatures(for account: AccountModel) -> [FeatureModel]`: Возвращает список доступных функций для счета пользователя.
- `getUserAccounts(user: UserModel) -> [AccountModel]`: Получает список аккаунтов пользователя и возвращает их в виде массива `AccountModel`.

**MainRouterProtocol**
- `navigateToFeature(_ feature: FeatureType, account: AccountModel)`: Осуществляет переход к экрану, соответствующему выбранной функции. Также передает данные о выбранном аккаунте, чтобы загрузить его детали на следующем экране.

### Протоколы для экрана баланса (Balance)

**BalanceViewProtocol**
- `displayBalance(_ balance: BalanceModel)`: Отображает баланс выбранного аккаунта. Метод принимает объект `BalanceModel`, содержащий информацию о текущем балансе и валюте.
- `func showError(_ message: String)`: Отображает ошибку получения баланса на экране.

**BalancePresenterProtocol**
- `loadBalance(forAccount account: AccountModel)`: Запрашивает информацию о балансе для указанного аккаунта. Передает запрос в `Interactor` для получения данных и обновляет `View`, если данные получены.

**BalanceInteractorProtocol**
- `fetchBalance(forAccount account: AccountModel, completion: @escaping (Result<BalanceModel, Error>) -> Void)`: Запрашивает данные о балансе у внешнего источника (например, сервера или базы данных) для указанного аккаунта и передает результат (баланс или ошибку) в `Presenter`.

**BalanceRouterProtocol**
- `func navigateBack()`: Возвращает пользователя на главный экран.
- `func navigateToTransfer(account: AccountModel)`: Осуществляет переход к `Transfer`-экрану с переданным аккаунтом.

### Протоколы для экрана перевода (Transfer)

**TransferViewProtocol**
- `showTransferSuccess()`: Показывает сообщение об успешном завершении перевода.
- `showError(message: String)`: Показывает ошибку (например, недостаточно средств на аккаунте или неверные данные получателя).

**TransferPresenterProtocol**
- `makeTransfer(fromAccount: AccountModel, toAccount: AccountModel, amount: Double)`: Выполняет перевод средств с одного аккаунта на другой. Запрашивает `Interactor` для обработки перевода и сообщает View о результате.

**TransferInteractorProtocol**
- `processTransfer(fromAccount: AccountModel, toAccount: AccountModel, amount: Double, completion: @escaping (Result<Void, Error>) -> Void)`: Обрабатывает перевод средств между двумя аккаунтами. В случае успешной транзакции возвращает `Result.success`, в случае ошибки — `Result.failure` с подробным описанием ошибки (например, недостаток средств или ошибка сети).
- `func checkBalance(forAccount account: AccountModel, amount: Double) -> Bool`: Проверяет баланс пользователя и его возможность перевести сумму. Если средств досаточно, вызывается метод `processTransfer`, если нет, возвращается ошибка и вызывается метод `showError` в `View`.

**TransferRouterProtocol**
- `navigateToSuccessScreen()`: Перенаправляет пользователя на экран успеха (например, сообщение о завершении перевода или переход к следующему шагу после перевода).
- `func navigateBack()`: Возвращает пользователя на главный экран.

### Протоколы для экрана истории транзакций (History)

**HistoryViewProtocol**
- `displayTransactions(_ transactions: [TransactionModel])`: Отображает список транзакций для выбранного аккаунта. Метод принимает массив объектов `TransactionModel`, содержащих данные о каждой транзакции (например, сумма, дата и тип).
- `func showError(message: String)`: Показывает ошибку загрузки.

**HistoryPresenterProtocol**
- `loadTransactions(forAccount account: AccountModel)`: Запрашивает историю транзакций для указанного аккаунта. Взаимодействует с Interactor для получения данных и передает их `View` для отображения.
- `func didSelectTransaction(_ transaction: TransactionModel)`: Вызывает метод `Router`, который открывает экран с деталями транзакции. 

**HistoryInteractorProtocol**
- `fetchTransactions(forAccount account: AccountModel, completion: @escaping (Result<[TransactionModel], Error>) -> Void)`: Выполняет запрос транзакций для указанного аккаунта, взаимодействуя с внешним источником данных (например, сервером). Возвращает массив транзакций или ошибку.

**HistoryRouterProtocol**
- `func navigateToTransactionDetails(transaction: TransactionModel)`: Открывает экран с деталями транзакции. 

### Модели

**BalanceModel**
- `BalanceModel`: Содержит информацию о балансе пользователя на определенном аккаунте.

**TransactionModel**
- `TransactionModel`: Содержит данные о транзакции.

**AccountModel**
- `AccountModel`: Содержит информацию о счете пользователя.

**UserModel**
- `UserModel`:  Содержит информацию о пользователе.

**FeatureModel**
- `FeatureModel`: Сущность, необходимая для экрана со всеми возможностями приложения.