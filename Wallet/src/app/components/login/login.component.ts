import { Component, OnInit } from '@angular/core';
import {ApiService} from '../../services/api/api.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  public userId;
  public userPwd;

  constructor(private walletService: ApiService) { }

  ngOnInit() {
  }

  public logIn() {
    this.walletService.logIn(this.userId, this.userPwd).subscribe( response => {
      console.log(response);
    });
  }

}
