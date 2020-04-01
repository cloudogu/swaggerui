const config = require('./config');
const utils = require('./utils');

const webdriver = require('selenium-webdriver');
const By = webdriver.By;
const until = webdriver.until;

jest.setTimeout(30000);

let driver;

beforeEach(async() => {
    driver = utils.createDriver(webdriver);
    await driver.manage().window().maximize();
});

afterEach(async () => {
    await driver.quit();
});

describe('Swagger UI browser tests', () => {
    test('call page without login', async () => {
        let dogu_url = config.baseUrl + config.swaggerUIContextPath;
        await driver.get(dogu_url);
        const url = await driver.getCurrentUrl();
        expect(url).toMatch(dogu_url);
        await driver.wait(until.elementLocated(By.id('swagger-ui')), 5000);
    });

    test('landing page has no swagger spec loaded', async () => {
        await driver.get(config.baseUrl + config.swaggerUIContextPath);
        await driver.wait(until.elementLocated(By.xpath("//div[contains(@class, 'loading-container')]/h4[text() = 'No API definition provided.']")), 5000);
    });
});