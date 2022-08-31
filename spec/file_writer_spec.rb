require "spec_helper"
require "tmpdir"

describe FileWriter do

  let(:fname) { filewriter_tmpname }
  let(:backup) { fname + "~" }
  let(:fw)    { FileWriter.new(fname) }

  before do
    File.write(fname,"foo")
  end

  def overwrite
    fw.write("bar")
  end

  it "has a version number" do
    expect(FileWriter::VERSION).not_to be nil
  end

  it "FileWriter.new accepts a filename" do
    FileWriter.new(fname)
  end

  it "#fname returns the filename" do
    expect(fw.fname).to eq(fname)
  end

  it ".write(fname,contents) is equivalent to FileWriter.new(fname).write(contents)" do
    FileWriter.write(fname,"bar")
    expect(File.read(fname)).to eq("bar")
  end

  context "#write" do
    it "creates a new file if one does not already exist" do
      FileWriter.write(fname, "hello world")
      expect(File.read(fname)).to eq("hello world")
    end

    it "replaces the contents of the file" do
      overwrite
      expect(File.read(fname)).to eq("bar")
    end

    it "creates a backup file as filename+'~'" do
      overwrite
      expect(File.read(backup)).to eq("foo")
    end

    it "uses File#rename if possible" do
      expect(File).to receive(:rename).with(fname,fname+"~").and_call_original
      overwrite
    end

    it "falls back to copying the backup if File#rename fails" do
      expect(File).to receive(:rename) { raise SystemCallError.new("error") }
      overwrite
      expect(File.read(fname)).to eq("bar")
      expect(File.read(backup)).to eq("foo")
    end

    it "preserves the mode of the original file" do
      FileUtils.chmod(0750, fname)
      overwrite
      expect((File.stat(fname).mode & 07777).to_s(8)).to eq(0750.to_s(8))
    end

    it "preserves the mode of the original file in the backup file" do
      FileUtils.chmod(0750, fname)
      overwrite
      expect((File.stat(backup).mode & 07777).to_s(8)).to eq(0750.to_s(8))
    end

    it "calls File#fsync after overwriting the file" do
      expect_any_instance_of(File).to receive(:fsync).and_call_original
      overwrite
    end

    it "raises SystemCallError if writing the new contents fails" do
      expect_any_instance_of(File).to receive(:write) { 0 }
      expect {overwrite}.to raise_exception(SystemCallError)
    end

    it "handles writing of unicode characters" do
      FileWriter.write(fname,"\u25c2")
      expect(File.read(fname)).to eq("\u25c2")
    end

    it "writes files larger than SPLIT_SIZE correctly" do
      c = "x42" * (FileWriter::SPLIT_SIZE + 42)
      FileWriter.write(fname, c)
      expect(File.read(fname)).to eq(c)
    end

    it "leave the backup intact if writing the new contents fails" do
      expect_any_instance_of(File).to receive(:write) { 0 }
      expect {overwrite}.to raise_exception(SystemCallError)
      expect(File.read(backup)).to eq("foo")
    end
  end
end
