require 'spec_helper'

describe Rubedo::Connection::Options do
  let(:instance) { described_class.new(options) }

  let(:options) { {} }

  describe '#to_hash' do
    subject { instance.to_hash }

    describe 'aliases' do
      let(:options) do
        {
          user: 'foo',
          pass: 'bar'
        }
      end

      it 'contains specified fields' do
        expect(subject).to include(username: 'foo', password: 'bar')
      end

      it 'contains defaults' do
        expect(subject).to include(
          charset: 'utf8',
          slaves: Set[],
          pool_size: 5,
          pool_timeout: 5
        )
      end
    end

    describe 'properties' do
      let(:hash) do
        {
          adapter: 'do:postgres',
          database: 'mydb',
          password: 'secret',
          username: 'ptico',
          host: 'localhost',
          port: 1234,
          owner: 'ptico',
          charset: 'cp1251',
          collation: 'en_US.UTF-8',
          slaves: ['192.168.1.1', '192.168.1.2'],
          pool_size: 8,
          pool_timeout: 7
        }
      end

      let(:options) { hash }

      it 'contains all properties' do
        expect(subject).to match(hash)
      end
    end
  end

  describe '#adapter' do
    subject { instance.adapter }

    let(:options) do
      { adapter: 'do:postgres' }
    end

    it { expect(subject).to eql('do:postgres') }
  end

  describe '#database' do
    subject { instance.database }

    context 'when `database`' do
      let(:options) do
        { database: 'mydb' }
      end

      it { expect(subject).to eql('mydb') }
    end

    context 'when `dbname`' do
      let(:options) do
        { dbname: 'mydb' }
      end

      it { expect(subject).to eql('mydb') }
    end
  end

  describe '#password' do
    subject { instance.password }

    context 'when `password`' do
      let(:options) do
        { password: 'secret' }
      end

      it { expect(subject).to eql('secret') }
    end

    context 'when `pass`' do
      let(:options) do
        { pass: 'secret' }
      end

      it { expect(subject).to eql('secret') }
    end
  end

  describe '#username' do
    subject { instance.username }

    context 'when `username`' do
      let(:options) do
        { username: 'ptico' }
      end

      it { expect(subject).to eql('ptico') }
    end

    context 'when `user`' do
      let(:options) do
        { user: 'ptico' }
      end

      it { expect(subject).to eql('ptico') }
    end
  end

  describe '#host' do
    subject { instance.host }

    context 'when not specified' do
      it { expect(subject).to be_nil }
    end

    context 'when `host`' do
      let(:options) do
        { host: 'localhost' }
      end

      it { expect(subject).to eql('localhost') }
    end

    context 'when `socket`' do
      let(:options) do
        { socket: '/tmp/db.sock' }
      end

      it { expect(subject).to eql('/tmp/db.sock') }
    end

    context 'when specified in `servers` section' do
      let(:options) do
        {
          servers: {
            master: '127.0.0.1',
            slaves: []
          }
        }
      end

      it { expect(subject).to eql('127.0.0.1') }
    end
  end

  describe '#port' do
    subject { instance.port }

    context 'when not specified' do
      it { expect(subject).to be_nil }
    end

    context 'when integer' do
      let(:options) do
        { port: 1234 }
      end

      it { expect(subject).to eql(1234) }
    end

    context 'when string' do
      let(:options) do
        { port: '1234' }
      end

      it { expect(subject).to eql(1234) }
    end
  end

  describe '#owner' do
    subject { instance.owner }

    context 'when not specified' do
      it { expect(subject).to be_nil }
    end

    context 'when specified' do
      let(:options) do
        { owner: 'ptico' }
      end

      it { expect(subject).to eql('ptico') }
    end
  end

  describe '#charset' do
    subject { instance.charset }

    context 'when not specified' do
      it { expect(subject).to eql('utf8') }
    end

    context 'when `charset`' do
      let(:options) do
        { charset: 'cp1251' }
      end

      it { expect(subject).to eql('cp1251') }
    end

    context 'when `encoding`' do
      let(:options) do
        { encoding: 'cp1252' }
      end

      it { expect(subject).to eql('cp1252') }
    end
  end

  describe '#collation' do
    subject { instance.collation }

    context 'when specified' do
      let(:options) do
        { collation: 'en_US.UTF-8' }
      end

      it { expect(subject).to eql('en_US.UTF-8') }
    end
  end

  describe '#slaves' do
    subject { instance.slaves }

    context 'when not specified' do
      it { expect(subject).to eql(Set[]) }
      it { expect(subject).to be_empty }
    end

    context 'when specified as slaves' do
      let(:options) do
        {
          slaves: ['192.168.1.1', '192.168.1.2']
        }
      end

      it { expect(subject).to contain_exactly('192.168.1.1', '192.168.1.2') }
    end

    context 'when specified in `servers` section' do
      let(:options) do
        {
          servers: {
            master: '127.0.0.1',
            slaves: [
              '192.168.1.1',
              '192.168.1.2'
            ]
          }
        }
      end

      it { expect(subject).to contain_exactly('192.168.1.1', '192.168.1.2') }
    end
  end

  describe '#pool_size' do
    subject { instance.pool_size }

    context 'when not specified' do
      it { expect(subject).to eql(5) }
    end

    context 'when specified' do
      let(:options) do
        { pool_size: 8 }
      end

      it { expect(subject).to eql(8) }
    end

    context 'when specified as string' do
      let(:options) do
        { pool_size: '6' }
      end

      it { expect(subject).to eql(6) }
    end
  end

  describe '#pool_timeout' do
    subject { instance.pool_timeout }

    context 'when not specified' do
      it { expect(subject).to eql(5) }
    end

    context 'when specified' do
      let(:options) do
        { pool_timeout: 7 }
      end

      it { expect(subject).to eql(7) }
    end

    context 'when specified as string' do
      context 'when specified' do
        let(:options) do
          { pool_timeout: '6' }
        end

        it { expect(subject).to eql(6) }
      end
    end
  end
end
