import {Body, Controller, Get, Post, Query} from '@nestjs/common';
import {AdminService} from "./admin.service";

@Controller()
export class AdminController {
    constructor(private readonly adminService: AdminService) {}
}
