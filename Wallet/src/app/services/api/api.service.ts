import { Injectable } from '@angular/core';
import {HttpClient, HttpResponse} from '@angular/common/http';
import {Observable} from 'rxjs';
import {isArray} from 'util';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  public userId;

  private defaultGetOption = { observe: 'response' };
  private defaultPostOption = { observe: 'response' };

  constructor(private http: HttpClient) { }

  private get<T>(url: string | any[], params: {[params: string]: object}, option?: object): Observable<HttpResponse<T>> {
    let computedUrl;
    let computedOptions = (option) ? option : this.defaultGetOption;

    if (url instanceof Array) {
      computedUrl = url.join('/');
    } else {
      computedUrl = url;
    }

    if (params) {
      Object.assign({}, computedOptions, params);
    }

    return this.http.get<HttpResponse<T>>(computedUrl, computedOptions);
  }

  private post<T>(url: string | any[], params: {[params: string]: object}, option?: object): Observable<HttpResponse<T>> {
    let computedUrl;
    let computedOptions = (option) ? option : this.defaultPostOption;

    if (url instanceof Array) {
      computedUrl = url.join('/');
    } else {
      computedUrl = url;
    }

    if (params) {
      Object.assign({}, computedOptions, params);
    }

    return this.http.post<HttpResponse<T>>(computedUrl, computedOptions);
  }

  public logIn(userId, password) {
    return this.post('http://supinfo.steve-colinet.fr/supcooking/?action="login"&?login="' + userId + '"&?password="' + password + '"', {params: {
        action: 'login',
        login: userId,
        password: password
      }});
  }

  public register() {

  }

  public logOut() {

  }

  public getUserInfo() {

  }

  public sendTransaction(toUserId, amount) {

  }

  public getFullHistory() {

  }
}
