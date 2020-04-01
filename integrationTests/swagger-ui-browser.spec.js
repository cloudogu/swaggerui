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

    test('call page without login', async() => {
        await driver.get(config.baseUrl + config.swaggerUIContextPath);
        const url = await driver.getCurrentUrl();
        expect(url).toBe(config.baseUrl + config.swaggerUIContextPath + "/")
    });

    test('landing page has no swagger spec loaded', async() => {
        await driver.get(config.baseUrl + config.swaggerUIContextPath);
        await driver.wait(until.elementLocated(By.xpath("//div[contains(@class, 'loading-container')]/h4[text() = 'No API definition provided.']")), 5000);
        let downloadUrlInput = await driver.find(By.className('download-url-input'))
        expect(downloadUrlInput.value).toEqual("")
    });

});