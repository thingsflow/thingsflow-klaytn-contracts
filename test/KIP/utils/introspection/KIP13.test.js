const { shouldSupportInterfaces } = require('./SupportsInterface.behavior');
const { expectRevert } = require('@openzeppelin/test-helpers');

const KIP13Mock = artifacts.require('KIP13Mock');

contract('KIP13', function () {
  beforeEach(async function () {
    this.mock = await KIP13Mock.new();
  });

  it('register interface', async function () {
    expect(await this.mock.supportsInterface('0x00000001')).to.be.equal(
      false,
    );
    await this.mock.registerInterface('0x00000001');
    expect(await this.mock.supportsInterface('0x00000001')).to.be.equal(
      true,
    );
  });

  it('does not allow 0xffffffff', async function () {
    await expectRevert(
      this.mock.registerInterface('0xffffffff'),
      'KIP13: invalid interface id',
    );
  });

  shouldSupportInterfaces(['KIP13']);
});
