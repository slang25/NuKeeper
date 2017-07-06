﻿using System.Linq;
using NuKeeper.RepositoryInspection;
using NUnit.Framework;

namespace NuKeeper.Tests.RepositoryInspection
{
    [TestFixture]
    public class PackagesFileReaderTests
    {
        [Test]
        public void EmptyPackagesListShouldBeParsed()
        {
            const string emptyContents =
                @"<?xml version=""1.0"" encoding=""utf-8""?>
<packages>
</packages>";

            var packages = PackagesFileReader.Read(emptyContents);

            Assert.That(packages, Is.Not.Null);
            Assert.That(packages, Is.Empty);
        }

        [Test]
        public void SinglePackageShouldBeRead()
        {
            const string singlePackage = 
@"<?xml version=""1.0"" encoding=""utf-8""?>
<packages>
  <package id=""foo"" version=""1.2.3.4"" targetFramework=""net45"" />
</packages>";

            var packages = PackagesFileReader.Read(singlePackage);

            Assert.That(packages, Is.Not.Null);
            Assert.That(packages, Is.Not.Empty);
        }

        [Test]
        public void SinglePackageShouldBeCorrect()
        {
            const string singlePackage =
                @"<?xml version=""1.0"" encoding=""utf-8""?>
<packages>
  <package id=""foo"" version=""1.2.3.4"" targetFramework=""net45"" />
</packages>";

            var packages = PackagesFileReader.Read(singlePackage);

            var package = packages.FirstOrDefault();
            Assert.That(package, Is.Not.Null);
            Assert.That(package.Id, Is.EqualTo("foo"));
            Assert.That(package.Version, Is.EqualTo("1.2.3.4"));
        }

        [Test]
        public void TwoPackagesShouldBeRead()
        {
            const string packagesFile =
                @"<?xml version=""1.0"" encoding=""utf-8""?>
<packages>
  <package id=""foo"" version=""1.2.3.4"" targetFramework=""net45"" />
  <package id=""bar"" version=""2.3.4.5"" targetFramework=""net45"" />
</packages>";

            var packages = PackagesFileReader.Read(packagesFile)
                .ToList();

            Assert.That(packages, Is.Not.Null);
            Assert.That(packages.Count, Is.EqualTo(2));
            Assert.That(packages[0].Id, Is.EqualTo("foo"));
            Assert.That(packages[1].Id, Is.EqualTo("bar"));
        }
    }
}