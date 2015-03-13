Peer4commit FAQ
===============

What is Peer4Commit?
--------------------
With Peer4Commit you can add projects from GitHub and donate Peercoins to the ones that interest you the most. Anyone that submits code changes and has them accepted will receive Peercoin tips. This helps in providing an incentive for developers to work on important projects that will benefit Peercoin in the future. Peer4commit was adapted by Sigmike from Tip4commit.

What is a Commit?
-----------------
Each time someone adds changes to the source code of a supported project, they receive 1% of the project balance. A set of changes is called a "commit". Here is an example commit for Peercoin v0.4: https://github.com/ppcoin/ppcoin/commit/5941effd0085dd26ce9b793ec09dcaffae8e5678

How do I Receive a Tip for my Commit?
-------------------------------------
We use the email address included in the commit to identify the author and notify them. To receive the tip, the author must follow the link in the email they received and set their Peercoin address. If they don't do that within 1 month, the tip goes back to the project balance.

How do I Donate to a Project I Like?
------------------------------------
You can see all supported projects here: http://peer4commit.com/projects. To donate to a specific project, open up the page for that project and just send Peercoins to the address that is displayed. For an example, check out Peercoin's main project page: http://peer4commit.com/projects/19. If the project you want to donate to is not supported yet, go to the supported projects page and just copy/paste its GitHub URL (For example: https://github.com/ppcoin/ppcoin) into the input box above the list. Anyone can add a project to Peer4commit, even if you are not the project maintainer. 99% of your donation will be given as tips. 1% will be kept to host the website and pay the transaction fees.

How do I Push my Commits?
-------------------------
Getting write access to the "Master" of a project involves that the project maintainer provides access to you in Github. This type of access would only be given to people trusted by the maintainer. If you already have write access to the project, just push your commits to the default branch of the project as usual. Otherwise, you'll have to fork the project (i.e. Start your own project based on the supported project), make some changes and create a pull request to propose your changes. If your pull request is accepted (Merged), you'll receive one tip per commit. If the changes are simple enough, you can do them in your browser by editing the files on GitHub. Otherwise, you'll have to use Git to clone your fork, make some changes, commit them and push the commits to GitHub. You can find a lot of information about that on GitHub help and on the web.

Make Sure You Read the Project Charter & Tipping Policies Before Starting
-------------------------------------------------------------------------
Project maintainers can refuse your commits for several reasons. It is important to read the "Charter" of the project on its GitHub page, which usually provides guidance on which commits and under what rules they would be accepted. For example, there are very strict rules for contributing to the official ppcoin/ppcoin project. A good way to ensure the maintainer is willing to merge your changes is to first create an issue explaining what you're going to do and ask if they would merge a pull request. Wait for an answer before starting. The project owner can also edit the Tipping Policies section on their Peer4commit project page to include more information on what kind of commits will be tipped. So it's important to read both the project charter on GitHub and the tipping policies that are listed on Peer4commit.

Can Project Owners Change the Amount Donated to Each Commit?
------------------------------------------------------------
Yes, they have a new button "Change project settings" on the project page along the project name. In this screen they can change 2 things (for now):

* A text describing their tipping policies that will be displayed on the project page on peer4commit.
* A checkbox that will put all new tips on hold when commits are found.

When the checkbox is active, each new commit generates an "Undecided" tip and the authors are not notified. The project owners can then click on a new button on the project page to decide the tip amounts. They have these choices:

* Leave undecided (To decide later)
* Free (The commit won't get any tip and the author won't be notified)
* Tiny: 0.1% of the project balance.
* Small: 0.5% of the project balance.
* Normal: 1%
* Big: 2%
* Huge: 5%

The authors are notified when the tip amount is decided (Unless they have recently been notified already, or if they said they don't want any more notification, or if they have configured their Peercoin address). The 2 buttons are only available to project collaborators (Those who can push changes to the supported repository). There should be more options in the future. Your ideas are welcome.

Do You Have an Audit Page Setup for Peer4commit?
------------------------------------------------
Yes, Peer4commit does have an audit page. It shows different information, such as amount donated, available balance, transaction fees, amount in cold storage and includes addresses for each project. You can view the page here: http://peer4commit.com/audit.

What Measures Have Been Taken to Secure the Funds on Peer4Commit?
-----------------------------------------------------------------
The project funds are isolated in different accounts in the wallet, so if someone ever finds a way to get more tips than the project balance, Peercoin will not take the funds from another project and will refuse the transaction. Projects with a high balance have a part of its funds moved to cold storage. This is still a manual operation, but will soon be automated. The website runs in an isolated virtual server running only this service.

Conclusion
-----------
The commit may not be the best item to identify the value of a contribution, but it's a very convenient way to identify contributors and send them donations. The maintainer of the project doesn't even have to do anything. Supporters can add a project from GitHub and start donating without any extra work on the project side (Except setting their address if they want the tips). A commit can include very important changes that took a very long time to build (Like the v0.4 changes) or a very small change like adding a comma.

Contact
-------
If you have any questions, either post them in this thread, message Sigmike on PeercoinTalk.org: http://www.peercointalk.org/index.php?action=profile;u=30141 on Reddit: http://www.reddit.com/user/sigmike or open an issue on GitHub: https://github.com/sigmike/peer4commit/issues.

References:
-----------
Fork: https://help.github.com/articles/fork-a-repo
Pull Request: https://help.github.com/articles/using-pull-requests
Git: https://help.github.com/articles/set-up-git
Github Help: https://help.github.com/
