/**
 * Define services providing access to your data model entities in here.
 * Adjust namespaces, names, entities and the file name and add more files as appropriate.
 * https://help.sap.com/viewer/DRAFT/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/3a56562e4b2f43b8bff9f8211e37b72c.html
 */
namespace my.service;
using my.data.model as data from '../db/data-model';

service FooService {
    entity Foo as projection on data.Foo;
    //...
}
